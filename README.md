# colorsel

SPA that renders rgb.txt in a way that reminds Xaw3d utility xcolorsel.

## Compile

	# npm install -g make-commonjs-depend bower
	
    $ make depend
	$ make

and look into `app.devel` directory.

For production mode run:

	$ export NODE_ENV=production
	$ make clean
	$ make depend
	$ make

and look into `app` directory.

Generated `app.devel` or `app` could be given to any static http
server. For testing purposes, run:

    $ make http

and point a browser to http://localhost:8080/app.devel/

## License

MIT.
