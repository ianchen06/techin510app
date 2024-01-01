.PHONY: build

build:
    docker build -t techin510app .

run:
    docker run -it --rm -p 8080:8080 techin510app