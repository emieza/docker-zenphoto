# docker-zenphoto
The popular picture gallery CMS for Docker.

## Requirements
The container needs to populate **port 80** for accessing Apache.

It also needs to mount 2 volumes:
- /var/lib/mysql : to make the DB changes persistent
- /var/www/html : to make the uploads persistent

## Run it!
Just try out something like:
```sh
docker run -p 9002:80 --name=zenphoto \
        -v zenphoto/mysql:/var/lib/mysql \
        -v zenphoto/www:/var/www/html \
        -d emieza/zenphoto
```

First time run will need more time to create MySQL database.

You will have to access with your browser to your machine, something like:
        http://mydockermachine:9002

...and follow the instructions to setup the CMS.

## Making extra albums available
One of the excellent features of Zenphoto is that you can upload
directly to your server via FTP, SFTP, samba, etc. So, you may
like to add albums to your gallery by mounting additional volumes
and then adding symlinks to access from the CMS to them.

Just add that line to the previous docker run command:

    -v zenphoto/morealbums:/morealbums 


And then access your running container and make the symlink:

    $ docker exec -ti zenphoto /bin/bash
    # ln -s /morealbums /var/www/html/albums/morealbums

Et voilà! :)

