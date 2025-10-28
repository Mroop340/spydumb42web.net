<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProcessSpy extends Model
{
    protected $table  = 'spytables';
    protected $fillable = ['Process',	'IsComplete',	'IsRun'	
];

    public $timestamps = false;
}
