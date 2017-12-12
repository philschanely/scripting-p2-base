<?php

require_once 'application/libraries/Service.php';

/**
 * Created by IntelliJ IDEA.
 * User: philschanely
 * Date: 4/19/17
 * Time: 2:56 PM
 */

class Category_model extends CI_Model {

    var $entity;
    var $key;
    var $properties;
    var $plural;
    var $single;
    var $service;
    var $_entries;

    public function __construct()
    {
        parent::__construct();
        $this->load->database();

        $this->entity = 'Category';
        $this->plural = 'categories';
        $this->single = 'category';
        $this->key = 'id';
        $this->properties = array(
            'id',
            'name',
            'owner'
        );
        $this->belongs_to = array();
        $this->has_one = array(
            'owner' => 'User'
        );
        $this->has_many = array(
           'category' => 'Task'
        );
        $this->do_not_return = array('owner');
        $this->default_sorts = 'name';

        $this->service = new Service(array(
            'entity' => $this->entity,
            'properties' => $this->properties,
            'key' => $this->key,
            'plural' => $this->plural,
            'single' => $this->single,
            'belongs_to' => $this->belongs_to,
            'has_one' => $this->has_one,
            'has_many' => $this->has_many,
            'do_not_return' => $this->do_not_return,
            'default_sorts' => $this->default_sorts
        ));
    }

    public function route($_key=NULL)
    {
        return $this->service->route($_key);
    }

}
