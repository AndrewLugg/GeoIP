<?php

function get_ip()
{
    $ip = isset($_SERVER['HTTP_X_FORWARDED_FOR'])  ? $_SERVER['HTTP_X_FORWARDED_FOR'] : $_SERVER['REMOTE_ADDR'];
    if ($ip == "") {$ip = $_SERVER['REMOTE_ADDR'];}

    if(strpos($ip,',') !== false) {
        $ip = substr($ip,0,strpos($ip,','));
    }
    return $ip;
}
function xml_encode($mixed, $domElement=null, $DOMDocument=null): void
{
    if (is_null($DOMDocument)) {
        $DOMDocument =new DOMDocument;
        $DOMDocument->formatOutput = true;
        xml_encode($mixed, $DOMDocument, $DOMDocument);
        echo $DOMDocument->saveXML();
    }
    else {
        // To cope with embedded objects
        if (is_object($mixed)) {
            $mixed = get_object_vars($mixed);
        }
        if (is_array($mixed)) {
            foreach ($mixed as $index => $mixedElement) {
                if (is_int($index)) {
                    if ($index === 0) {
                        $node = $domElement;
                    }
                    else {
                        $node = $DOMDocument->createElement($domElement->tagName);
                        $domElement->parentNode->appendChild($node);
                    }
                }
                else {
                    $plural = $DOMDocument->createElement($index);
                    $domElement->appendChild($plural);
                    $node = $plural;
                    if (!(rtrim($index, 's') === $index)) {
                        $singular = $DOMDocument->createElement(rtrim($index, 's'));
                        $plural->appendChild($singular);
                        $node = $singular;
                    }
                }

                xml_encode($mixedElement, $node, $DOMDocument);
            }
        }
        else {
            $mixed = is_bool($mixed) ? ($mixed ? 'true' : 'false') : $mixed;
            $domElement->appendChild($DOMDocument->createTextNode($mixed));
        }
    }
}



use MaxMind\Db\Reader;
// This creates the Reader object, which should be reused across
// lookups.
$reader = new Reader('/usr/share/GeoIP/GeoLite2-City.mmdb');

$path = $_SERVER['REQUEST_URI'];
$pathParts = explode("?", $path);
$pathParts = explode("/", $pathParts[0]);

if (strlen($pathParts[2]) > 0) {
    $ip = $pathParts[2];
} else {
    $ip = get_ip();
}

error_log(print_r($pathParts, true));


$data = $reader->get($ip);

if ($pathParts[1] == "xml") {
    $response = ["Responese" => [
        "IP"=> $ip,
        "CountryCode" => $data['country']['iso_code'],
        "CountryName" => $data['country']['names']['en'],
        "TimeZone" => $data['location']['time_zone'],
        "RegionCode" => $data['subdivisions'][0]['iso_code'],
        "RegionName" => $data['subdivisions'][0]['names']['en'],
        "City" => $data['city']['names']['en'],
        "ZipCode" => $data['postal']['code'],
        "Latitude" => $data['location']['latitude'],
        "Longitude" => $data['location']['longitude']
        ]
    ];
    header('Content-Type:application/xml');
    xml_encode([$response]);
} else {
    $response = [
        "ip"=> $ip,
        "country_code" => $data['country']['iso_code'],
        "country_name" => $data['country']['names']['en'],
        "time_zone" => $data['location']['time_zone'],
        "region_code" => $data['subdivisions'][0]['iso_code'],
        "region_name" => $data['subdivisions'][0]['names']['en'],
        "city" => $data['city']['names']['en'],
        "zip_code" => $data['postal']['code'],
        "latitude" => $data['location']['latitude'],
        "longitude" => $data['location']['longitude']
    ];
    header('Content-Type:application/json');
    echo json_encode($response);
}


