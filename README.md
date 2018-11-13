**/api/json**  
  
- **GET**  
	Si llamamos a _/api/json_ devuelve el listado de gnomos  
  
**/api/users**  
  
- **POST**  
  
	-- /createUser {username / password}  
	-- /login  
	Para hacer login debemos llamar a api/users/login  
	AUTHORIZATION: Basic Username y Password  
  
**/api/comments**  
  
- **GET**  
  
	-- /1  -> Devuelve el comentario con Id = 1  
	-- ?gnomeId=1  -> Devuelve todos los comentarios de gnomo con Id = 1  
	-- /count?gnomeId=1  -> Retorna el número de comentarios que tiene el gnomo con Id =1  
	-- /all  -> Devuelve todos los comentarios (Requiere autenticación)  
  
- **POST (requiere autenticación)**  
-- Si llamamos a _/api/comments_ y pasamos los datos del comentario se dará de alta. Ejemplo:  
  
	**HEADER**:  
	Authorization: Bearer XXXXXXXXXXXX  
	**BODY (URLEncoded)**:  
	title:  Título del comentario  
	comment: Texto del comentario  
	gnomeId:  3  
	userId:  usuario  