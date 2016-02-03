#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import javax.inject.Singleton;

import kikaha.urouting.api.DefaultResponse;
import kikaha.urouting.api.ExceptionHandler;
import kikaha.urouting.api.Mimes;
import kikaha.urouting.api.Response;

@Singleton
public class NotFoundExceptionHandler implements ExceptionHandler<NotFoundException> {

	@Override
	public Response handle( NotFoundException exception ) {
		return DefaultResponse.notFound()
				.contentType( Mimes.PLAIN_TEXT )
				.entity( exception.getMessage() );
	}
}
