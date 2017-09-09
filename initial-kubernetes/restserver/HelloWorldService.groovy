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

interface HelloWorldService {
  def greet(name)
}

class LocalHelloWorldService implements HelloWorldService {
  def greet(name) {
    return [greeting: "Hello ${name} from local service", version: "local"]
  }
}

class RestHelloWorldService implements HelloWorldService {
  def uri = ""
  def rest = new RestTemplate()

  def greet(name) {
    return rest.getForObject("${uri}/${name}", Map.class);
  }
}
