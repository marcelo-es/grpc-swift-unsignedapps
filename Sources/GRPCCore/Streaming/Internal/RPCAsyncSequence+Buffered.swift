/*
 * Copyright 2023, gRPC Authors All rights reserved.
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

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension RPCAsyncSequence {
  @inlinable
  static func makeBackpressuredStream(
    of elementType: Element.Type = Element.self,
    watermarks: (low: Int, high: Int)
  ) -> (stream: Self, writer: RPCWriter<Element>.Closable) {
    let (stream, continuation) = BufferedStream.makeStream(
      of: Element.self,
      backPressureStrategy: .watermark(low: watermarks.low, high: watermarks.high)
    )

    return (RPCAsyncSequence(wrapping: stream), RPCWriter.Closable(wrapping: continuation))
  }

  @inlinable
  public static func _makeBackpressuredStream(
    of elementType: Element.Type = Element.self,
    watermarks: (low: Int, high: Int)
  ) -> (stream: Self, writer: RPCWriter<Element>.Closable) {
    return Self.makeBackpressuredStream(of: elementType, watermarks: watermarks)
  }
}