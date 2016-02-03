#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

public class NotFoundException extends RuntimeException {

	private static final long serialVersionUID = 7643753262003253504L;

	public NotFoundException() {
		super( "The resource you were looking for does not exists." );
	}
}
