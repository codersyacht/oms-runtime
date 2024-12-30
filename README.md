chmod 777 -R ./*

./build-container.sh

docker exec -it omsruntime bash

cd ..

./build-images.sh

exit

<container deployment>

./build-localenv.sh
