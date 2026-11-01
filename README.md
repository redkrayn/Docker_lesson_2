# Сайт доставки еды Star Burger

Это сайт сети ресторанов Star Burger. Здесь можно заказать превосходные бургеры с доставкой на дом.

![скриншот сайта](https://dvmn.org/filer/canonical/1594651635/686/)


Сеть Star Burger объединяет несколько ресторанов, действующих под единой франшизой. У всех ресторанов одинаковое меню и одинаковые цены. Просто выберите блюдо из меню на сайте и укажите место доставки. Мы сами найдём ближайший к вам ресторан, всё приготовим и привезём.

На сайте есть три независимых интерфейса. Первый — это публичная часть, где можно выбрать блюда из меню, и быстро оформить заказ без регистрации и SMS.

Второй интерфейс предназначен для менеджера. Здесь происходит обработка заказов. Менеджер видит поступившие новые заказы и первым делом созванивается с клиентом, чтобы подтвердить заказ. После оператор выбирает ближайший ресторан и передаёт туда заказ на исполнение. Там всё приготовят и сами доставят еду клиенту.

Третий интерфейс — это админка. Преимущественно им пользуются программисты при разработке сайта. Также сюда заходит менеджер, чтобы обновить меню ресторанов Star Burger.

Сайт располагается [здесь](http://194.156.101.200)
## Как запустить dev-версию сайта

Перед началом скачайте Docker, если не сделали этого ранее. Подробную информацию об установке вы можете получить [здесь](https://www.docker.com/get-started/).

Скачайте код:
```bash
git clone https://github.com/devmanorg/star-burger.git
```

Перейдите в каталог проекта:
```bash
cd star-burger
```

Определите переменные окружения. Создайте файл `.env` в каталоге `star_burger/` и положите туда:
```bash
SECRET_KEY="Ключ джанго"
GEOAPP_TOKEN="Я использовал яндекс геокодер получить ключ можно в [кабинете разработчика](https://developer.tech.yandex.ru/services)"
DEBUG="True"
POSTGRES_DB="Название вашей бд"
POSTGRES_USER="Логин"
POSTGRES_PASSWORD="Пароль"
```

Запустите Docker-compose:
```bash
docker compose -f docker-compose.dev.yml up --build
```

Вполните миграции и создайте администратора:
```bash
docker compose exec backend python manage.py migrate
```

```bash
docker compose exec backend python manage.py createsuperuser
```

Откройте сайт в браузере по адресу [http://localhost:8000](http://localhost:8000). Поздравляю вы запустили dev-версию сайта.

## Как запустить prod-версию сайта

Скачайте репозиторий с гитхаба:
```bash
git clone git@github.com:git/repo /home/root/PSB
```

Установите nginx:
```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo rm /etc/nginx/sites-enabled/default
```

Создайте файл конфигурации проекта:
```bash
sudo nano /etc/nginx/sites-available/PSB
```

В файл вставьте конфиг ниже:
```bash
server {
    listen 80;
    server_name ваш ip;

    location /static/ {
        alias /home/root/PSB/staticfiles/;
    }

    location /media/ {
        alias /home/root/PSB/media/;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Активируйте и проверьте конфиг:
```bash
sudo ln -s /etc/nginx/sites-available/PSB /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

Создайте файл .env.prod и определите пременные окружения:
```bash
sudo nano PSB/.env.prod
```

```bash
SECRET_KEY="Ключ джанго"
GEOAPP_TOKEN="Я использовал яндекс геокодер получить ключ можно в [кабинете разработчика](https://developer.tech.yandex.ru/services)"
DEBUG="False"
POSTGRES_DB="Название вашей бд"
POSTGRES_USER="Логин"
POSTGRES_PASSWORD="Пароль"
ALLOWED_HOSTS='127.0.0.1,localhost,Ip вашего сервера'
```

Добавим себя в права на управление Docker:
```bash
sudo usermod -aG docker $USER
```

Запустите скрипт деплоя:
```bash
bash scripts/deploy.sh
```

Поздравляю, теперь у вас есть полностью докеризированный сайт в открытом доступе!

## Цели проекта

Код написан в учебных целях — это урок в курсе по Python и веб-разработке на сайте [Devman](https://dvmn.org). За основу был взят код проекта [FoodCart](https://github.com/Saibharath79/FoodCart).
