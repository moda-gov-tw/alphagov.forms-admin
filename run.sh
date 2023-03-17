docker run -it \
    --name web_form \
    -e GOVUK_APP_DOMAIN=0.0.0.0 \
    -e PAAS_ENVIRONMENT=development \
    -e RAILS_ENV=development \
    -e NODE_ENV=development \
    -e DATABASE_URL="postgres://rails:password@db/rails" \
    --link form_db:db \
    --link govuk_form_runner \
    --link govuk_form_api \
    --user root \
    -p 127.0.0.1:3000:3000 \
    govuk-form:latest sh
