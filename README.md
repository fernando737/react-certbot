#Commands
## Get the basic react app (Only reference, no need to run)
```bash
docker compose -f docker-compose-prod.yml run --rm frontend sh -c "npm create vite@latest my-react-app --template react"
```
## Run the app interactively
```bash
docker compose -f docker-compose-prod.yml run --rm frontend sh
```