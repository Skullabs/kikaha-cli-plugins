#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import java.util.Collection;

import javax.inject.Inject;
import javax.inject.Singleton;

import kikaha.core.api.Source;
import kikaha.urouting.api.Consumes;
import kikaha.urouting.api.DELETE;
import kikaha.urouting.api.DefaultResponse;
import kikaha.urouting.api.GET;
import kikaha.urouting.api.Mimes;
import kikaha.urouting.api.POST;
import kikaha.urouting.api.PUT;
import kikaha.urouting.api.Path;
import kikaha.urouting.api.PathParam;
import kikaha.urouting.api.Produces;
import kikaha.urouting.api.Response;

import com.hazelcast.core.IMap;
import com.hazelcast.core.IdGenerator;

@Singleton
@Path( "user" )
@Consumes( Mimes.JSON )
@Produces( Mimes.JSON )
public class UserResource {

	@Inject
	@Source( "user-repository" )
	IdGenerator idGenerator;

	@Inject
	@Source( "user-repository" )
	IMap<Long, User> repository;

	@POST
	public Response createUser( User user ) {
		final Long newId = idGenerator.newId();
		saveUser( user, newId );
		return DefaultResponse.created()
				.header( "ID", newId.toString() );
	}

	@PUT
	@Path( "{id}" )
	public void updateUser( User user, @PathParam( "id" ) Long id ) {
		if ( !repository.containsKey( id ) )
			throw new NotFoundException();
		saveUser( user, id );
	}

	private void saveUser( User user, final Long newId ) {
		repository.put( newId, user );
	}

	@GET
	public Collection<User> retrieveAllUsers() {
		return repository.values();
	}

	@GET
	@Path( "{id}" )
	public User retrieveUser( @PathParam( "id" ) Long id ) {
		final User user = repository.get( id );
		if ( user == null )
			throw new NotFoundException();
		return user;
	}

	@DELETE
	@Path( "{id}" )
	public void deleteUser( @PathParam( "id" ) Long id ) {
		if ( !repository.containsKey( id ) )
			throw new NotFoundException();
		repository.remove( id );
	}
}
