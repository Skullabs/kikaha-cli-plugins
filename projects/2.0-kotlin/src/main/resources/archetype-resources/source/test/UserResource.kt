package test

import kikaha.urouting.api.GET
import kikaha.urouting.api.POST
import kikaha.urouting.api.Path
import kikaha.urouting.api.PathParam
import java.util.*
import javax.inject.Singleton

@Path( "users" )
@Singleton
class UserResource {

    val users = HashMap<Long, User>()
  
    @GET
    fun retrieveAllUsers() = users.values

    @GET
    @Path( "{id}" )
    fun retrieveUserById( @PathParam( "id" ) id:Long ) = users.get( id )

    @POST
    fun persistUser( user:User ) {
        users.put( user.id, user )
    }
}

