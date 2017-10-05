/*
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import org.springframework.web.client.*

interface GuestbookService {
  def add(username, message)
  def all()
}

class LocalGuestbookService implements GuestbookService {
  def add(username, message) {
    return [username: username, message: message, timestamp: new Date()]
  }
  def all() {
    return [[username: 'a', message: 'a message', timestamp: new Date()],
            [username: 'b', message: 'b message', timestamp: new Date()]]
  }
}

class RestGuestbookService implements GuestbookService {
  def uri = ""
  def rest = new RestTemplate()

  def add(username, message) {
    rest.postForObject(uri, [username: username, message: message, timestamp: new Date()], Map.class)
  }

  def all() {
    def messages = [];
    def resp = rest.getForObject(uri, Map.class)

    // FIXME =(
    resp.links.each() {
      if (it.rel != 'self') {
        messages << rest.getForObject(it.href, Map.class)
      }
    }

    return messages;
  }
}
