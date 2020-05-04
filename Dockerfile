FROM edimossilva/rails6:latest

COPY ./nps_count/Gemfile /app/Gemfile
COPY ./nps_count/Gemfile.lock /app/Gemfile.lock

WORKDIR /app
RUN bundle install