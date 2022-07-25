# Shortener URL 

### Prerequisites
* [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
   
### Installation
1. Download [Code Backend](https://github.com/HuyVo-3107/url-shortener)
    * Run docker command
     ```sh
        cd url-shortener
        docker build -t shortener_url_api:latest .
     ``` 
    * Host: http://localhost:3000
2. Download [Code Frontend](https://github.com/HuyVo-3107/shortener-url-frontend)
    * Run docker command 
     ```sh
        cd shortener-url-frontend
        docker build -t shortener_url_frontend:latest .
     ``` 
      * Host: http://localhost
3. Run docker-compose.yml
    * Run docker command
     ```sh
        cd shortener-url-frontend
        docker-compose up -d
     ``` 
4.  [Login](http://localhost/auth/login) or [Register](http://localhost/auth/register)