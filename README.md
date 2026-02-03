# java-cicd-demo

Local dev + CI/CD demo:
- Java Spring Boot service (port 8080)
- Python FastAPI service (port 8000)
- Docker Compose for local testing
- GitHub Actions builds images, pushes to ECR, deploys to EC2 via SSM

## Quick local run
\`\`\`bash
# from repo root
docker compose build --no-cache
docker compose up -d
docker compose logs -f
# endpoints
curl http://localhost:8000/api/time
curl http://localhost:8080/api/hello
curl http://localhost:8080/api/call-python
\`\`\`

## Build & test Java locally
\`\`\`bash
mvn -B -DskipTests package
java -jar target/*.jar
\`\`\`

## GitHub / AWS notes
- The Actions workflow expects AWS credentials (or OIDC role) and ECR repos to exist.
- Tag EC2 instance \`Role=deploy-target\` so CI can target it via SSM.

## Files of interest
- \`Dockerfile\` — multi-stage Java build
- \`python-service/Dockerfile\` — Python image
- \`.github/workflows/ci-cd.yml\` — CI/CD pipeline
- \`cloud-init-userdata.sh\` — EC2 user-data (for bootstrapping)
