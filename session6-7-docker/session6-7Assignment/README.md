Session 6-7 - Docker

Made Hello World web apps for Node.js, Python, Java, Apache, React and Nginx, each in
its own folder with its own Dockerfile. Also built and ran the multi-stage Dockerfile
on port 8080. Task 2 write-up (name, enrollment no, screenshots) is in
documentation.md. All the curl output and docker ps is in output.txt.

How to run them all:

```
docker build -t nodejs-app nodejs-app
docker run -d --name nodejs -p 3001:3000 nodejs-app
```

(same pattern for the rest - ports are 8080 multistage, 3001 node, 5001 python,
8081 java, 8082 apache, 8083 nginx, 3002 react)

What I learned:

A Dockerfile is basically just "start from this base image, copy my files in, run this
command". The base image does most of the work - nginx and apache ones are 3 lines
because the image already knows how to serve a folder.

Multi-stage builds use one stage to build and a second to run, so the build tools don't
end up in the final image. The React one goes from a node image (to build) to an nginx
image (to serve) and the final image is only 102MB instead of carrying all of node.

Also -p 8080:3000 means host port 8080 goes to container port 3000. They don't have to
match, which is how I ran 7 apps at once without clashing.
