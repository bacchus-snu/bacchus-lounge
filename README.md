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

## Bacchus-lounge 띄우기

Docker와 docker-compose를 잘 설치했다면 할 일이 많지는 않습니다.

1. ZNC 설정 파일 생성

    ```bash
    docker-compose run znc --makeconf
    ```

    admin 유저네임과 비밀번호를 설정하고, 포트는 6697, ssl 켜고, 나머지는 default로 하고 network setting은 당장 하지 말고 znc를 당장 켜지도 않으면 됩니다.

1. 띄우기!

    ```bash
    docker-compose up -d
    ```

    ZNC, thelounge, caddy의 환상적인 콜라보가 시작됩니다.

## ZNC 설정

ZNC에서 간단한 설정을 통해 8080 포트를 열어줘야 합니다.

1. 6697 포트 tunneling 하기

    먼저, local에서, 6697 포트를 ssh tunneling을 통해 접근해봅시다.

    ```bash
    local$ ssh -L 8080:localhost:6679 <host>
    ```

1. 접속하기

    local의 웹 브라우저에서 `https://localhost:8080`으로 접속합시다.
    잘 설정했다면 ZNC web interface로 접근이 됩니다. 설정해둔 admin 계정으로 접속합니다.

    global settings에서, SSL, IPv6, IRC를 끈 8080번 포트를 열어줍니다. 이제 tunneling 없이 Caddyfile에서 설정한 주소로 ZNC web interface에 접근할 수 있습니다.

## 유저 추가하기

이전 olmeca 서비스보다 user를 추가하는 작업이 살짝 복잡해졌습니다.

1. ZNC 유저 추가하기

    ZNC web interface의 manage users에서, 유저를 추가하고, 이름과 비밀번호를 설정하고 네트워크에 접속시켜줍니다.

1. thelounge 유저 추가하기

    ```bash
    docker-compose run thelounge thelounge add <username>
    ```

    비밀번호를 설정하고, 로그는 저장하지 않도록 설정합니다.

1. thelounge로 접속하기

    발급한 thelounge 계정으로 일단 접속합니다. 왼쪽 하단에 + 버튼을 통해 network를 추가합니다.
    Nickname이나 Real name은 상관이 없지만, Username과 Password는 중요합니다.

    Username은 `<ZNC의 username>/<ZNC에서 설정한 네트워크>` 가 되야 합니다.
    예를 들면 `pbzweihander/UriIRC`

    Password는 ZNC 계정의 비밀번호를 적어야합니다.

    username와 password 둘 다 thelounge와 통일시켜놓으면 헷갈릴 일이 없습니다.

    그리고 유저에게 이메일로 thelounge 및 ZNC 계정의 username과 password를 알려줍니다.

## ZNC 인증서 업데이트하기

ZNC의 web interface에 접속할 때나, 다른 IRC 클라이언트로 ZNC에 직접 접속할 때는 ZNC의 인증서를 사용하게 됩니다.
하지만 당연히 이 인증서는 valid 하지 않습니다.

그래서 caddy의 인증서를 대신 가져다 쓰는 방법을 쓰면 ZNC도 valid한 인증서를 쓸 수 있습니다.

안타깝게도 caddy는 인증서를 알아서 재발급 받지만 그 새로 발급 받은 인증서를 ZNC에 물리는건 자동으로 해주지 않습니다.
매달 직접 복사해줘야합니다.

Docker의 volume에서 인증서를 복사하는 container는 `caddy-cert-to-znc`에 만들어 두었고 `docker-compose.yml`에도 등록해놓았습니다.

그러므로 매달 caddy가 인증서를 재발급 받아서 ZNC의 인증서가 만료되면 다음 커맨드를 실행시켜 인증서를 복사해줘야합니다.

```bash
docker-compose run cert-copier
```
