package main

import (
	"os"

	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/joho/godotenv"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
)

type CdkStackProps struct {
	awscdk.StackProps
}

func NewCdkStack(scope constructs.Construct, id string, props *CdkStackProps) awscdk.Stack {
	var sprops awscdk.StackProps
	if props != nil {
		sprops = props.StackProps
	}
	stack := awscdk.NewStack(scope, &id, &sprops)

	return stack
}

func main() {
	defer jsii.Close()

	err := godotenv.Load(".env", ".env.safe")
	if err != nil {
		panic("Error loading .env file")
	}

	app := awscdk.NewApp(nil)

	NewCdkStack(app, "CdkStack", &CdkStackProps{
		awscdk.StackProps{
			Env: env(),
		},
	})

	app.Synth(nil)
}

func env() *awscdk.Environment {
	return &awscdk.Environment{
		Region: jsii.String(os.Getenv("AWS_REGION")),
	}
}
