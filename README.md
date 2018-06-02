# Bacchus Lounge

bacchus-lounge는 [olmeca](olmeca.snucse.org)에서 돌아가는 웹 IRC 클라이언트 서비스입니다.

------

이하는 작업기록입니다.

## Docker 설치

[Reference](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Docker는 저장소를 따로 추가해서 설치해야합니다.

1. 일단 `apt update`

    ```bash
    sudo apt update
    ```

1. `apt`가 HTTPS를 통해 저장소를 이용하기 위한 prerequisites를 설치합시다.

    ```bash
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    ```

1. Docker의 GPG 키를 추가합니다.

    ```bash
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```

    Key의 fingerprint가 `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`인 것을 확인합시다.
    마지막 8글자를 검색해서 확인할 수 있습니다.

    ```bash
    $ sudo apt-key fingerprint 0EBFCD88

    pub   4096R/0EBFCD88 2017-02-22
        Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    uid                  Docker Release (CE deb) <docker@docker.com>
    sub   4096R/F273FCD8 2017-02-22
    ```

1. Docker repository를 추가합시다! (x86_64의 기준으로 적었습니다.)

    ```bash
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    ```

1. 다시 `apt update`

    ```bash
    sudo apt update
    ```

1. Docker를 설치합니다.

    ```bash
    sudo apt install docker-ce
    ```

1. 현재 user를 docker 그룹에 추가합시다.

    docker 그룹에 추가되면 sudo 없이도 docker를 이용할 수 있습니다. 근데 docker 그룹 자체가 sudo랑 비슷한 권한을 갖는다던가 하여간 보안상 좋지 않다고 했으므로 sudoer만 docker 그룹에 추가합시다.

    ```bash
    sudo usermod -aG docker $USER
    ```

1. 설치 끝!

    ```bash
    $ docker -v
    Docker version 18.03.1-ce, build 9ee9f40
    ```

## Docker-comose 설치

[Reference](https://docs.docker.com/compose/install/)

Docker-compose는 `apt` repository에도 있지만 버전이 낮기 때문에, referece에서 소개하는 binary를 직접 받는 방법으로 설치해봅시다.

1. Binary 받기

    [Docker-compose release 페이지](https://github.com/docker/compose/releases)에서 최신 버전을 확인하고 그 버전을 받도록 합니다. 지금은 1.21.2가 최신이므로 1.21.2를 받겠습니다.

    ```bash
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    ```

1. Permission 설정

    ```bash
    sudo chmod +x /usr/local/bin/docker-compose
    ```

1. 설치 끝!

    ```bash
    $ docker-compose -v
    docker-compose version 1.21.2, build a133471
    ```
