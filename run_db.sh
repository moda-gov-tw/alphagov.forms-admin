docker run -d \
    -e POSTGRES_USER=rails \
    -e POSTGRES_PASSWORD=password \
    -p 5432:5432 \
    --name form_db \
    postgres
