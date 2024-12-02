# Below path set for testing purpose only
# Update it once we make final change
cd ./example/ios/Runner/Base.lproj

STORYBOARD_FILE="LaunchScreen.storyboard"

sed -i '' '/<view[^>]*id="Ze5-6b-2t3"[^>]*>/,/<\/view>/d' "$STORYBOARD_FILE"

# Insert the new view after the closing </scene> tag (or after the appropriate tag in your file)
sed -i '' '/<\/layoutGuides>/a \
<view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">\
    <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>\
    <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>\
    <subviews>\
        <imageView opaque="NO" clipsSubviews="YES" multipleTouchEnabled="YES" contentMode="scaleAspectFit" image="LaunchImage" translatesAutoresizingMaskIntoConstraints="NO" id="YRO-k0-Ey4">\
            <rect key="frame" x="0.0" y="176" width="393" height="500"/>\
        </imageView>\
    </subviews>\
    <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>\
    <constraints>\
        <constraint firstItem="YRO-k0-Ey4" firstAttribute="centerX" secondItem="Ze5-6b-2t3" secondAttribute="centerX" id="1a2-6s-vTC"/>\
        <constraint firstItem="YRO-k0-Ey4" firstAttribute="centerY" secondItem="Ze5-6b-2t3" secondAttribute="centerY" id="4X2-HB-R7a"/>\
        <constraint firstAttribute="trailing" secondItem="YRO-k0-Ey4" secondAttribute="trailing" id="am5-vK-Ba3"/>\
        <constraint firstItem="YRO-k0-Ey4" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="ku5-PA-unI"/>\
    </constraints>\
</view>' "$STORYBOARD_FILE"

echo "LaunchScreen view changed successfully"