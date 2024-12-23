# local-llm

Stack to deploy a Local Language Learning Model (LLM) and securely expose Docker Services.

Using:

- Ollama
- Open WebUI
- NGINX (reverse proxy)
- Cloudflare Tunnel

## Prerequisites

- This stack assumes that Docker and Docker Compose are installed on your machine.
- It is assumed that you are using a Linux distribution or WSL2 (Windows Subsystem for Linux version 2) on Windows.
- Ensure you have already configured your Cloudflare domain and set up the Tunnel with Zero Trust enabled.

## How is it Secure?

The stack utilizes several security measures:

- Docker manages image deployments, maintaining a secure environment for service isolation.
- Separate networks are used for different components (e.g., Cloudflare Tunnel and NGINX reverse proxy on the frontend network; Open WebUI and Ollama on the backend network).
- Implement Content Security Policies to restrict resources that can be loaded, reducing cross-site scripting attacks. You may need to update these policies if you wish to incorporate additional endpoints.
- Rate limiting helps protect against DDoS (Distributed Denial of Service) attacks by controlling the frequency at which users can send requests.

## 1 - Clone the repo

`git clone https://github.com/brodseba/local-llm.git`

## 2 - Run setup.sh script with your Cloudflare Tunnel domain (run only once).

`./setup.sh  <YOUR_DOMAIN>`

## 3 - Edit the .env file to add your CloudFlare Tunnel Token:

## 4 - Update periodically the Docker Image using update.sh script:
`./update.sh`

Enjoy!
