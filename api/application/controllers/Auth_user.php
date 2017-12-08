<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Auth_User extends CI_Controller {

    function __construct()
    {
        parent::__construct();
        $this->load->model('user_model');
    }

    public function index($_key='all')
    {
        $result = $this->user_model->route($_key);
        $auth = (object) array(
            'authenticated' => false,
            'user' => NULL
        );
        if (isset($result->users) && !empty($result->users)) {
            $auth->authenticated = true;
            $auth->user = $result->users[0];
            unset($auth->user->password);
        } elseif (is_object($result) && !empty($result->id)) {
            $auth->authenticated = true;
            $auth->user = $result;
            unset($auth->user->password);
        }
        echo json_encode($auth);
    }

}
