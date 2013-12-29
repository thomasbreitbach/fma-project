<?php
/**
 * Step 1: Require the Slim Framework
 *
 * If you are not using Composer, you need to require the
 * Slim Framework and register its PSR-0 autoloader.
 *
 * If you are using Composer, you can skip this step.
 */
require 'Slim/Slim.php';
require 'RedBean/rb.php';

\Slim\Slim::registerAutoloader();

// set up database connection
R::setup('mysql:host=localhost;dbname=u12715_fma','u12715_fma','fma2013');
R::freeze(true);

/**
 * Step 2: Instantiate a Slim application
 *
 * This example instantiates a Slim application using
 * its default settings. However, you will usually configure
 * your Slim application now by passing an associative array
 * of setting names and values into the application constructor.
 */
$app = new \Slim\Slim();



/**
*
* TAGEBUCH
*
*/

/*
***********************************
* Resource
*	/books
***********************************
*/
$app->get('/books/', function () use ($app) {
    // query database for all articles
    $books = R::getAll('select * from books');

    // send response header for JSON content type
    $app->response()->header('Content-Type', 'application/json');

    // return JSON-encoded response body with query results
    echo json_encode($books);
});


$app->post('/books/', function () use ($app) {
    try {
	// get and decode JSON request body
	$request = $app->request();
	$body = $request->getBody();

	$input = json_decode($body); 

	// store article record
	$book = R::dispense('books');
	$book->title = (string)$input->title;
	$book->author = (string)$input->author;
	$book->date = (string)$input->date;
	$book->auth_id = (int)$input->auth_id;

	$id = R::store($book);    
    
    	// return JSON-encoded response body
    	$app->response()->header('Content-Type', 'application/json');
    	echo json_encode(R::exportAll($book));
    } catch (Exception $e) {
	$app->response()->status(400);
	$app->response()->header('X-Status-Reason', $e->getMessage());
    }
});




/*
***********************************
* Resource:
*	/books/{book-id}
***********************************
*/
$app->get('/books/:id/', function ($id) use ($app) {
    try {
        // query database for all articles
        $book = R::findOne('books', 'id = ?', array($id));

        if($book){
            $app->response()->header('Content-Type', 'application/json');
            echo json_encode(R::exportAll($book));
        }else{
	    //no book found--> 404
            $app->response()->status(404);
        }
    }catch (ResourceNotFoundException $e) {
        // return 404 server error
        $app->response()->status(404);
    } catch (Exception $e) {
        $app->response()->status(400);
        $app->response()->header('X-Status-Reason', $e->getMessage());
    }
});


$app->put('/books/:id/', function ($id) use ($app) {    
  try {
    $request = $app->request();
    $body = $request->getBody();
    $input = json_decode($body); 
    
    $book = R::findOne('books', 'id=?', array($id));  

    if ($book) {      
      //update book
      if($input->title)
	$book->title = (string)$input->title;
      if($input->author)
      	$book->author = (string)$input->author;
      
      R::store($book);    
      $app->response()->header('Content-Type', 'application/json');
      echo json_encode(R::exportAll($book));
    } else {
      $app->response()->status(404);  
    }
  } catch (ResourceNotFoundException $e) {
    $app->response()->status(404);
  } catch (Exception $e) {
    $app->response()->status(400);
    $app->response()->header('X-Status-Reason', $e->getMessage());
  }
});


$app->delete('/books/:id/', function ($id) use ($app) {    
    try {
	$request = $app->request();
	$book = R::findOne('books', 'id=?', array($id));


	// delete book and entries
	if ($book) {
	    R::trash($book);
	    //entries werden automatisch von der db gelöscht
	    //sobald das buch gelöscht wird!
	    
	    $app->response()->status(204);
	} else {
	    throw new ResourceNotFoundException();
	}
     } catch (ResourceNotFoundException $e) {
	     $app->response()->status(404);
     } catch (Exception $e) {
	$app->response()->status(400);
	$app->response()->header('X-Status-Reason', $e->getMessage());
     }
});



/*
***********************************
* Resource:
*	/books/{book-id}/entries
***********************************
*/
$app->get('/books/:id/entries/', function ($id) use ($app) {
    try {
        // query database for all articles
        $entries = R::getAll( 'select * from entries where book_id = :book_id',
			array(':book_id'=>$id));
	
        if($entries){
            $app->response()->header('Content-Type', 'application/json');
            echo json_encode($entries);
        }else{
            throw new ResourceNotFoundException();
        }
    }catch (ResourceNotFoundException $e) {
        // return 404 server error
        $app->response()->status(404);
    } catch (Exception $e) {
        $app->response()->status(400);
        $app->response()->header('X-Status-Reason', $e->getMessage());
    }
});


$app->post('/books/:book_id/entries/', function ($book_id) use ($app) {
    try {
	// get and decode JSON request body
	$request = $app->request();
	$body = $request->getBody();

	$input = json_decode($body); 

	// store article record
	$entry = R::dispense('entries');
	$entry->title = (string)$input->title;
	$entry->date = (string)$input->date;
	$entry->text = (string)$input->text;
	$entry->mood = (string)$input->mood;
	$entry->pic_id = (int)$input->pic_id;
	$entry->location_long = $input->location_long;
	$entry->location_lati = $input->location_lati;

	$entry->book_id = $book_id;

	$id = R::store($entry);    
    
    	// return JSON-encoded response body
    	$app->response()->header('Content-Type', 'application/json');
    	echo json_encode(R::exportAll($entry));
    } catch (Exception $e) {
	$app->response()->status(400);
	$app->response()->header('X-Status-Reason', $e->getMessage());
    }
}); 

$app->delete('/books/:id/entries/', function ($id) use ($app) {
    try {
        // query database for all articles	
	$entries = R::find('entries', 'book_id = :id', array(':id' => $id));

        if ($entries) {
	    R::trashAll($entries);
	    $app->response()->status(204);
	} else {
	    $app->response()->status(404);
	}
    }catch (ResourceNotFoundException $e) {
        // return 404 server error
        $app->response()->status(404);
    } catch (Exception $e) {
        $app->response()->status(400);
        $app->response()->header('X-Status-Reason', $e->getMessage());
    }
});


/*
***********************************
* Resource:
*	/books/{book-id}/entries/{entry-id}
***********************************
*/
$app->get('/books/:bid/entries/:eid/', function ($bid, $eid) use ($app) {
    try {
        // query database for all articles
        $book = R::getAll( 'select * from entries 
				where book_id = :book_id
				AND id = :e_id',
			array(':book_id'=>$bid, ':e_id'=>$eid));

        if($book){
            $app->response()->header('Content-Type', 'application/json');
            echo json_encode($book);
        }else{
            $app->response()->status(404);
        }
    }catch (ResourceNotFoundException $e) {
        // return 404 server error
        $app->response()->status(404);
    } catch (Exception $e) {
        $app->response()->status(400);
        $app->response()->header('X-Status-Reason', $e->getMessage());
    }
});


$app->put('/books/:bid/entries/:eid/', function ($bid, $eid) use ($app) {    
  try {
    $request = $app->request();
    $body = $request->getBody();
    $input = json_decode($body); 
    
    $entry = R::findOne('entries', 
			'id = :e_id AND book_id=:book_id',
			array(':e_id' => $eid, ':book_id' => $bid));

    if ($entry) {      
      //update book
      if($input->title)
      	$entry->title = (string)$input->title;
      if($input->text)
	$entry->text = (string)$input->text;
      if($input->mood)
	$entry->mood = (string)$input->mood;
      if($input->pic_id)
	$entry->pic_id = (int)$input->pic_id;      
      if($input->location_long)
	$entry->location_long = $input->location_long;
      if($input->location_lati)
	$entry->location_lati = $input->location_lati;
      
      R::store($entry);    
      $app->response()->header('Content-Type', 'application/json');
      echo json_encode(R::exportAll($entry));
    } else {
      $app->response()->status(404);  
    }
  } catch (ResourceNotFoundException $e) {
    $app->response()->status(404);
  } catch (Exception $e) {
    $app->response()->status(400);
    $app->response()->header('X-Status-Reason', $e->getMessage());
  }
});


$app->delete('/books/:bid/entries/:eid/', function ($bid, $eid) use ($app) {    
    try {
	$request = $app->request();
	$entry = R::findOne('entries', 
			'id = :id AND book_id = :book_id',
			array(':id' => $eid, ':book_id' => $bid));

	var_dump($entry);

	if ($entry) {
	    R::trash($entry);
	    $app->response()->status(204);
	} else {
	    $app->response()->status(404);
	}
     } catch (ResourceNotFoundException $e) {
	     $app->response()->status(404);
     } catch (Exception $e) {
	$app->response()->status(400);
	$app->response()->header('X-Status-Reason', $e->getMessage());
     }
});


/**
 * Step 4: Run the Slim application
 *
 * This method should be called last. This executes the Slim application
 * and returns the HTTP response to the HTTP client.
 */
$app->run();
?>
