# Gameserver

Repository used to build the game server Docker image, for the Multiplayer Gaming Platform demo.

## CI/CD

At each commit, a Docker image is built and deployed in a dedicated aws ECR repository, with a unique tag.
The [terraform demo project](https://github.com/thomasjean-louis/infra) is deployed once again, to update the docker image defined in the ECS task definition.

## Run

The game server docker image runs inside an Ecs Fargate task, behind a [proxy](https://github.com/thomasjean-louis/proxy) container.

## Credits

- [inolen/quakejs](https://github.com/inolen/quakejs) - The original QuakeJS project.
- [ioquake/ioq3](https://github.com/ioquake/ioq3) - The community supported version of Quake 3 used by QuakeJS. It is licensed under the GPLv2.
- [treyyoder/quakejs-docker](https://github.com/treyyoder/quakejs-docker/tree/master) - The original quakeJs docker image I started working with.
- [joz3d.net](http://www.joz3d.net/html/q3console.html) - Useful information about configuration values.
