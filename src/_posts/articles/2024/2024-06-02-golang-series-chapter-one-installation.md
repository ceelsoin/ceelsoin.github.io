---
layout: post
title:  "Golang series: Chapter one - Installation"
description: Let's start our first series at this blog. We will learn golang.
tags: golang introduction tutorial
lang: en
# image: 
---

Hey everyone, this is the first tutorial series in my blog. We will learn golang, or simply called Go. 

For follow this tutorial series you just will need a computer running Windows, mac or linux (any linux).  Because Go is a general purpose and multi platform language. Also Go is open source that means you can contribute for the language improvements and fixes. 

## Why i chosen Go?

I've hear about Go 5 years ago by one college friend that was working in a finance startup with Go. He just talked that was a very fast language and simply to start. I confess that i didn't care much at the time...

4 years ago, I started to work at Globo, a brazilian television company that use Go in most part of theis systems, for high traffic softwares, and i started my journey with Go.

## Is hard to work with Go?

My experience starting with Go, was very easy to learn. Specially if you already use another language. Go implements very simply techniques for computer programming and straight to the point concepts like threads, pointers and vars.

Go dont use classes, but use packages, is like classes but without hierarchy, that simplify the code design. 


## Reasons to learn Go?

- Easy to learn
- Fast compilation (yes its a compilated language)
- Static linging
- Designed for easy work with concurrent programs
- Adoption by market (Lot of companies using and hot opportunities)
- A cute mascot called Gopher
- Native garbage collection
- Open source

## Popular softwares made with go
If are you a software developer or student you may use go everyday. Some products of our day was made with Go like docker, kubernetes, dropbox and a lot of companies use Go like netflix, google, uber, twitch paypal and more.

## Let's Start!

For install go in your machine you need to do some steps, i will split by operating system, follow the steps of your operating system below:

### MacOS
 For the first step, install homebrew as your package manager in mac (this will be very nice for install many developer tools at mac) running:

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Now you can install go using Homebrew

```bash
$ brew install go
```
### Linux
For linux, depending of your distro follow the commands below for installation and the rest of the steps will be the same.

#### Ubuntu / Debian
```sh
sudo apt update
sudo apt install -y Golang
```

#### Fedora

```sh
sudo dnf install -y golang
```
#### ArchLinux

```sh
sudo pacman -S go

```

### Windows

<small>If are you using WSL (Windows subsystem for linux) you can do the same steps for linux. If its not your case, follow the steps below:</small>

1. Download the MSI installer from https://go.dev/dl/. 

2. Double tap to start the installation and follow the prompts. This will install Go in location c:\Go and will also add the directory c:\Go\bin to your path environment variable.

3. Now you can do the command to see go installed on your windows machine:


## Checking your installation

If everything was installed ok you can run go version for check if go was installed on your machine

```bash
$ go version
```

The output might be like this: 

```bash
➜  ~ go version
go version go1.21.5 darwin/arm64
```

(The version or architecture can be different depending of your system or installed version, but its ok)

If you can't se version output, check your environment variables to ensure your installation can be found by your terminal.

