<?php

$imageStr = json_decode($_POST["imageStr"]);

//put a cover pic
$folder_path = "output/output_image/temp.png";
$data = str_replace('data:image/png;base64,', '', $imageStr[0]);
$data = str_replace(' ', '+', $data);
$data = base64_decode($data);
file_put_contents($folder_path, $data);
chmod("output/output_image/temp.png", 0777);
 
for ($a = 0; $a < count($imageStr); $a++)
{
    $folder_path = "images/" . $a . "-" . time() . ".png";
 
    $picture = $imageStr[$a];
    $data = str_replace('data:image/png;base64,', '', $picture);
    $data = str_replace(' ', '+', $data);
    $data = base64_decode($data);
 
    file_put_contents($folder_path, $data);
 
}
file_put_contents("images/flag.txt", $data);

//echo shell_exec("sh /Users/jue/Sites/pictures/t.sh");
//exec("/Users/jue/Sites/pictures/activation_test.app");

//shell_exec("python /Users/jue/Sites/pictures/test.py");

echo "Image has been uploaded";

?>
