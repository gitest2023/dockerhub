# 1. Create image and push it dockerhub
    docker build -f ./Dockerfile -t phich82/amazonlinux:1.0 .
    docker images
    docker login
    docker tag phich82/amazonlinux:1.0 phich82/amazonlinux:1.0-release
    docker push phich82/amazonlinux:1.0-release

# 2. Update image
    Update Dockerfile
    docker build -f ./Dockerfile -t phich82/amazonlinux:1.0 .
    docker images
    docker login
    docker tag phich82/amazonlinux:1.0 phich82/amazonlinux:1.0-release
    docker push phich82/amazonlinux:1.0-release

# 3. Update image version
    Update Dockerfile
    docker build -f ./Dockerfile -t phich82/amazonlinux:<new-version> .
    docker images
    docker login
    docker tag phich82/amazonlinux:<new-version> phich82/amazonlinux:<new-version>-release
    docker push phich82/amazonlinux:<new-version>-release

# 4. Run container
    docker run --name amazonlinux -p 80:80 -d phich82/amazonlinux:1.0