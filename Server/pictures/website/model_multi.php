<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    
    <style type="text/css">

        .myimg{
          width:150px;
          height:150px;
          object-fit:cover;
          border-radius:10%;
          margin:10px 10px 10px 15px;

        }

    </style>
</head>

<br>

<!--
<div align="left">

    <a rel="ar" href="/pictures/others/out.usdz", align="left">
        <img src="/pictures/others/out1.png", class= "myimg">
    </a>
</div>
-->



<div align="left">
    <?php
        $dirname = "/Users/jue/Sites/pictures/output/output_model/";
        $models = glob($dirname."*.usdz");

        $dirname_server = "/pictures/output/output_model/";
        $dir_image = "/pictures/output/output_image/";
        
        foreach($models as $model) {
            $model_name = pathinfo($model);
            $image_name = $model_name['filename'];
            $model_name = $model_name['filename'].'.usdz';
            $image_name .= '.png';
            echo '<a rel="ar" href='.$dirname_server.$model_name.'><img src="'.$dir_image.$image_name.'", class= "myimg"></a>';
            
            
        }
    ?>
</div>
</html>
