#downloading 6th lab from git
svn checkout https://github.com/yurenianastya/databases-labs/trunk/6lab_spring
#renaming dir
mv 6lab_spring springapp
#building containers from my images
docker build database
docker build springapp
#connecting and starting containers
docker-compose up -d
#showing logs from spring app
docker logs iotspring-docker