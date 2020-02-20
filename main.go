package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"runtime"
	"strings"
	"syscall"
)

var (
	dir     = flag.String("d", "/vault/secrets", "directory to read files from")
	fail    = flag.Bool("f", false, "fail if missing directory")
	verbose = flag.Bool("v", false, "verbose")
)

func init() {
	runtime.GOMAXPROCS(1)
	runtime.LockOSThread()

	flag.Parse()
}

func main() {
	*dir = strings.TrimRight(*dir, "/")
	env := []string{}
	info, err := ioutil.ReadDir(*dir)
	if err != nil {
		if *verbose {
			fmt.Println(*dir)
		}
		if *fail {
			panic(err)
		}
	} else {
		for _, file := range info {
			if file.IsDir() {
				continue
			}
			if file.Name()[0] == '.' {
				continue
			}
			path := *dir + "/" + file.Name()
			if *verbose {
				fmt.Printf("==> %s\n", path)
			}
			kv, err := ParseEnvFile(path)
			if err != nil {
				panic(err)
			}
			if *verbose {
				found := make([]string, len(kv))
				for idx, v := range kv {
					s := strings.SplitN(v, "=", 2)
					found[idx] = s[0]
				}
				fmt.Printf("%s\n", found)
			}
			env = append(env, kv...)
		}

	}
	if *verbose {
		fmt.Printf("==> Running %s\n", flag.Args())
	}
	syscall.Exec(flag.Arg(0), flag.Args(), env)
}
