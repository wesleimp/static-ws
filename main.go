package main

import (
	"errors"
	"fmt"
	"net/http"
	"os"
	"path/filepath"

	"github.com/apex/log"
	"github.com/apex/log/handlers/text"
	"github.com/gin-gonic/contrib/static"
	"github.com/gin-gonic/gin"
	"github.com/urfave/cli/v2"
)

var version = "v0.1.0"

type Server struct {
	Port  string
	Path  string
	Index string
}

func (s Server) Start() error {
	gin.SetMode(gin.ReleaseMode)

	router := gin.Default()
	router.Use(static.Serve("/", static.LocalFile(s.Path, true)))

	router.NoRoute(func(c *gin.Context) {
		c.File(filepath.Join(s.Path, s.Index))
	})

	router.GET("/_ah/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "health",
		})
	})

	log.WithField("port", s.Port).Info("Starting server")
	return router.Run(fmt.Sprintf(":%s", s.Port))
}

func main() {
	log.SetHandler(text.Default)
	app := &cli.App{
		Name:            "static-ws",
		Usage:           "Serve static content",
		ArgsUsage:       "<PATH>",
		HideHelpCommand: true,
		Version:         version,
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:    "port",
				Usage:   "Application port address",
				Aliases: []string{"p"},
				EnvVars: []string{"PORT"},
				Value:   "8080",
			},
			&cli.StringFlag{
				Name:    "entrypoint",
				Usage:   "Refers to the index file",
				EnvVars: []string{"ENTRYPOINT"},
				Value:   "index.html",
			},
		},
		Action: run,
	}

	err := app.Run(os.Args)
	if err != nil {
		log.WithError(err).Error("failed to start application")
	}
}

func run(c *cli.Context) error {
	args := c.Args()
	if args.Len() < 1 {
		return errors.New("wrong number of arguments")
	}
	path := args.Get(0)

	err := validatePath(path)
	if err != nil {
		return err
	}

	s := Server{
		Path:  path,
		Port:  c.String("port"),
		Index: c.String("entrypoint"),
	}

	return s.Start()
}

func validatePath(p string) error {
	_, err := os.Stat(p)
	return err
}
