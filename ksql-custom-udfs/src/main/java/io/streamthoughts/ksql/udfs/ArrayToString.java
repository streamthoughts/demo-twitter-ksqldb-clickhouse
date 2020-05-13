/*
 * Copyright 2020 StreamThoughts.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.streamthoughts.ksql.udfs;

import io.confluent.ksql.function.udf.Udf;
import io.confluent.ksql.function.udf.UdfDescription;
import io.confluent.ksql.function.udf.UdfParameter;

import java.util.List;
import java.util.stream.Collectors;

@UdfDescription(
    name = "array_to_string",
    description = "Concatenates array elements using supplied delimiter and null string")
public class ArrayToString {


    @Udf
    public <T> String arrayToString(@UdfParameter("array") final List<T> array,
                                    @UdfParameter("delimiter") final String delimiter,
                                    @UdfParameter("nullString") final String nullString) {
        if (array == null) return nullString;
        return array
            .stream()
            .map(Object::toString)
            .collect(Collectors.joining(delimiter));
    }
}
