package test

import lombok.*

@Data
class User {

    val id = System.currentTimeMillis()
    var name:String? = null
}
