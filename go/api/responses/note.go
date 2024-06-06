package responses

type NoteResponse struct {
	ID        uint            `json:"id"`
	Title     string          `json:"title"`
	Content   string          `json:"content"`
	Author    UserRoleReponse `json:"author"`
	CreatedAt string          `json:"createdAt"`
	UpdateAt  string          `json:"updateAt"`
}
