# Step 1: Choose your base image
FROM rocker/r-ver:4.3.0

# Step 2: Install your system dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev \
  libicu-dev \
  libsodium-dev \
  libssl-dev \
  && apt-get clean

# Step 3: Install R packages
RUN Rscript -e "install.packages('plumber')"
COPY plumber.R /api/plumber.R

# Start 4: Do something
# Need to expose port for app
EXPOSE 8000 
ENTRYPOINT ENTRYPOINT ["R", "-e", "plumber::plumb('/api/plumber.R')$run(host = '0.0.0.0', port = 8000)"]
 