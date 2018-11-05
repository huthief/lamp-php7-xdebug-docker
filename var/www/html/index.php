<?php
$world = "PHP Docker with composer";
echo "Hello" . $world;

class test {
    public $pub = false;
    private $priv = true;
    protected $prot = 42;
}
$t = new test;
$t->pub = $t;
$data = array(
    'one' => 'This is xdebug test! If see this , xdebug is ready',
    'two' => array(
            'two.one' => array(
                'two.one.zero' => 210,
            ),
    ),
);
var_dump($data);

phpinfo();
?>