/*
 * Copyright 2011-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import org.springframework.context.annotation.*
import org.springframework.core.type.*
import org.springframework.data.redis.connection.jedis.*
import org.springframework.session.data.redis.config.annotation.web.http.*
import org.springframework.session.web.http.*
import org.springframework.web.filter.*
import org.springframework.boot.context.embedded.*
import org.springframework.boot.web.servlet.*;

@Grab("org.springframework.session:spring-session-data-redis:1.0.0.RELEASE")
@Configuration
class ApplicationConfig {
  @Value("#{systemEnvironment['HELLOWORLDSERVICE_PORT']}")
  String serviceEndpoint

  @Value("#{systemEnvironment['GUESTBOOKSERVICE_PORT']}")
  String guestbookServiceEndpoint

  @Bean
  @Primary
  def HelloWorldService helloWorldService() {
    def uri

    if (serviceEndpoint?.trim()) {
      uri = serviceEndpoint.replace("tcp:", "http:") + "/hello"

      println "Using backend: ${uri}"
      return new RestHelloWorldService(uri: uri)
    } else {
      println "Using local backend"
      return new LocalHelloWorldService()
    }
  }

  @Bean
  @Primary
  def GuestbookService guestbookService() {
    def uri

    if (guestbookServiceEndpoint?.trim()) {
      uri = guestbookServiceEndpoint.replace("tcp:", "http:") + "/api/messages"

      println "Using backend: ${uri}"
      return new RestGuestbookService(uri: uri)
    } else {
      println "Using local backend"
      return new LocalGuestbookService()
    }
  }
}
