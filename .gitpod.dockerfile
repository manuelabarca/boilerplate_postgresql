FROM gitpod/workspace-postgres


###
### APACHE SETUP
###

# Hack Apache's Config
RUN sudo sed -i 's/ServerRoot ${GITPOD_REPO_ROOT}/ServerRoot \/home\/gitpod\/.apache/g' /etc/apache2/apache2.conf
RUN sudo sed -i 's/${GITPOD_REPO_ROOT}\/${APACHE_DOCROOT_IN_REPO}/\/home\/gitpod\/.apache\/public/g' /etc/apache2/apache2.conf
RUN sudo sed -i 's/8001/8008/g' /etc/apache2/apache2.conf



###
### ADMINER SETUP
###

# Download Adminer
RUN sudo mkdir -p ~/.apache/public/plugins
RUN sudo wget -O ~/.apache/public/adminer-4.7.6-en.php https://github.com/vrana/adminer/releases/download/v4.7.6/adminer-4.7.6-en.php
RUN sudo wget -O ~/.apache/public/plugins/plugin.php https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php

# Create the runner file with plugins
# (this is intended to be open to extensions by adding plugins)
RUN sudo bash -c "echo $'<?php\n\
\n\
function adminer_object() { \n\
  include_once \"./plugins/plugin.php\"; \n\
\n\
  foreach (glob(\"plugins/*.php\") as \$filename) { \n\
      include_once \"./\$filename\"; \n\
  } \n\
\n\
  \$plugins = array( \n\
  ); \n\
\n\
  return new AdminerPlugin(\$plugins); \n\
} \n\
\n\
include \"./adminer-4.7.6-en.php\";' > ~/.apache/public/index.php"

# Give proper execution rights to the PHP files
RUN sudo chmod -R u+rwX,go+rX,go-w ~/.apache/public



###
### WORKSPACE SETUP
###

# Creates the `apache_start` command:
ENV PATH="$PATH:$HOME/.apache-bin"
RUN mkdir -p ~/.apache-bin \
  && printf "#!/bin/bash\napachectl start" > ~/.apache-bin/apache_start \
  && printf "#!/bin/bash\napachectl stop" > ~/.apache-bin/apache_stop \
  && printf "#!/bin/bash\napachectl restart" > ~/.apache-bin/apache_restart \
  && chmod +x ~/.apache-bin/*

# Autostart Apache
# (hack inspired by the postgres image)
RUN printf "\n# Auto-start Apache2 server.\napache_start > /dev/null\n" >> ~/.bashrc
ENV NODE_VERSION=14.14.0
RUN bash -c ". .nvm/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm alias default ${NODE_VERSION} && \
        npm install -g yarn"
ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH
