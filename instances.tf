data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "xps_key" {
  key_name   = "my-ec2-key"              # Name of the key pair
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key
}

# INSTANCES #

resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]
  key_name               = aws_key_pair.xps_key.key_name

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/ /home/ec2-user/ --recursive
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/* /usr/share/nginx/html/ --recursive

echo '
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  "$remote_addr - $remote_user [$time_local] \"$request\" "
                      "$status $body_bytes_sent \"$http_referer\" "
                      "\"$http_user_agent\" \"$http_x_forwarded_for\"";

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;
        index pages/index.html index.html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }

        # Serve content from pages directory
        location /pages/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;  # Try to serve file or return 404 if not found
        }

        # Serve static files (assets, css, js, etc.)
        location /assets/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /css/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /js/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /icons/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /libraries/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }
    }
}
' | sudo tee /etc/nginx/nginx.conf > /dev/null

sudo systemctl restart nginx
EOF

}



resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]
  key_name               = aws_key_pair.xps_key.key_name

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/ /home/ec2-user/ --recursive
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/* /usr/share/nginx/html/ --recursive

echo '
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  "$remote_addr - $remote_user [$time_local] \"$request\" "
                      "$status $body_bytes_sent \"$http_referer\" "
                      "\"$http_user_agent\" \"$http_x_forwarded_for\"";

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;
        index pages/index.html index.html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }

        # Serve content from pages directory
        location /pages/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;  # Try to serve file or return 404 if not found
        }

        # Serve static files (assets, css, js, etc.)
        location /assets/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /css/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /js/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /icons/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }

        location /libraries/ {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }
    }
}
' | sudo tee /etc/nginx/nginx.conf > /dev/null

sudo systemctl restart nginx
EOF


}


resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF

}
