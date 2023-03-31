chown -R root:root ./
apk add yarn bash npm
bin/setup
bin/rails db:seed
bin/dev
