package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/joho/godotenv"
)

var logger *log.Logger

func init() {
	logger = log.New(log.Default().Writer(), "[LAMBDA] ", log.LstdFlags)

	err := godotenv.Load()
	if err != nil {
		logger.Println("Aviso: Erro ao carregar .env file, continuando mesmo assim")
	}
}

func handler(ctx context.Context) error {
	bucketName := os.Getenv("TERRAFORM_STATE_BUCKET")
	if bucketName == "" {
		bucketName = "iagiliza-terraform-state-orchestrator"
	}

	stateFileName := "terraform.tfstate"

	execDir, err := os.Getwd()
	if err != nil {
		return fmt.Errorf("erro ao obter diretório atual: %v", err)
	}

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return fmt.Errorf("erro ao configurar cliente AWS: %v", err)
	}
	s3Client := s3.NewFromConfig(cfg)

	localStatePath := filepath.Join(execDir, stateFileName)
	err = downloadStateFile(ctx, s3Client, bucketName, stateFileName, localStatePath)
	if err != nil {
		logger.Printf("Aviso: Não foi possível baixar o arquivo tfstate do S3: %v. Pode ser a primeira execução.", err)
	}

	scriptPath := filepath.Join(execDir, "run-terraform.sh")
	cmd := exec.Command("/bin/bash", scriptPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err = cmd.Run()
	if err != nil {
		return fmt.Errorf("erro ao executar script: %v", err)
	}

	if _, err := os.Stat(localStatePath); err == nil {
		err = uploadStateFile(ctx, s3Client, bucketName, stateFileName, localStatePath)
		if err != nil {
			return fmt.Errorf("erro ao fazer upload do arquivo tfstate para S3: %v", err)
		}
		logger.Println("Arquivo tfstate enviado com sucesso para o S3")
	} else {
		logger.Println("Arquivo tfstate local não encontrado após execução do script")
	}

	return nil
}

func downloadStateFile(ctx context.Context, client *s3.Client, bucket, key, filePath string) error {
	logger.Printf("Tentando baixar arquivo de estado %s do bucket %s", key, bucket)

	file, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("falha ao criar arquivo local: %v", err)
	}
	defer file.Close()

	resp, err := client.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	_, err = io.Copy(file, resp.Body)
	if err != nil {
		return fmt.Errorf("falha ao escrever arquivo: %v", err)
	}

	logger.Printf("Arquivo de estado baixado com sucesso para %s", filePath)
	return nil
}

func uploadStateFile(ctx context.Context, client *s3.Client, bucket, key, filePath string) error {
	logger.Printf("Enviando arquivo de estado %s para o bucket %s", filePath, bucket)

	file, err := os.Open(filePath)
	if err != nil {
		return fmt.Errorf("falha ao abrir arquivo: %v", err)
	}
	defer file.Close()

	_, err = client.PutObject(ctx, &s3.PutObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
		Body:   file,
	})
	if err != nil {
		return fmt.Errorf("falha ao fazer upload: %v", err)
	}

	logger.Printf("Arquivo de estado enviado com sucesso para s3://%s/%s", bucket, key)
	return nil
}

func main() {
	lambda.Start(handler)
}
