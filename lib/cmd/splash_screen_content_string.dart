/*
 * Copyright (c) 2024 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/// Constraints element string
class SplashScreenContentString {
  static const String splashImageConstraints = '''<constraints>
  <constraint firstItem="YRO-k0-Ey4" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="3T2-ad-Qdv"/>
<constraint firstAttribute="trailing" secondItem="YRO-k0-Ey4" secondAttribute="trailing" id="TQA-XW-tRk"/>
<constraint firstItem="YRO-k0-Ey4" firstAttribute="bottom" secondItem="Ze5-6b-2t3" secondAttribute="bottom" id="duK-uY-Gun"/>
<constraint firstItem="YRO-k0-Ey4" firstAttribute="top" secondItem="Ze5-6b-2t3" secondAttribute="top" id="xPn-NY-SIU"/>
</constraints>''';

  /// These are constraints for splash image and background image.
  static const String splashAndBackConstraints = '''
  <constraints>
   <constraint firstItem="YRO-k0-Ey4" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="3T2-ad-Qdv"/>
   <constraint firstItem="edQ-YT-iED" firstAttribute="top" secondItem="Ze5-6b-2t3" secondAttribute="top" id="B02-Ap-adr"/>
   <constraint firstAttribute="trailing" secondItem="edQ-YT-iED" secondAttribute="trailing" id="T4v-vm-VRP"/>
   <constraint firstAttribute="trailing" secondItem="YRO-k0-Ey4" secondAttribute="trailing" id="TQA-XW-tRk"/>
   <constraint firstItem="YRO-k0-Ey4" firstAttribute="bottom" secondItem="Ze5-6b-2t3" secondAttribute="bottom" id="duK-uY-Gun"/>
   <constraint firstAttribute="bottom" secondItem="edQ-YT-iED" secondAttribute="bottom" id="e2S-gZ-2jl"/>
   <constraint firstAttribute="bottom" secondItem="edQ-YT-iED" secondAttribute="bottom" id="wnX-KJ-aN5"/>
   <constraint firstItem="YRO-k0-Ey4" firstAttribute="top" secondItem="Ze5-6b-2t3" secondAttribute="top" id="xPn-NY-SIU"/>
   <constraint firstItem="edQ-YT-iED" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="zVa-1q-mai"/>
</constraints>''';
}
