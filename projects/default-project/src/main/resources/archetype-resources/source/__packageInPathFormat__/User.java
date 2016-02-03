#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import java.io.Serializable;

import lombok.Data;

/**
 * User entity. The only reason it is serializable is because Hazelcast needs
 * entities to be store as serializable object. You can, optionally, change this
 * at the hazelcast.xml configuration file.
 */
@Data
public class User implements Serializable {

	private static final long serialVersionUID = 8588935807650557992L;

	String name;
	String username;
	String password;

}
