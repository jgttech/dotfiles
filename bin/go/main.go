package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	var lang string

	app := &cli.Command{
		Name: "install",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:        "lang",
				Aliases:     []string{"L"},
				Destination: &lang,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {
			fmt.Println("lang:", lang, cmd.Args().First())
			return nil
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}
