package responses

type ChatMessageResponse struct {
	ID        uint            `json:"id"`
	Content   string          `json:"content"`
	Author    UserRoleReponse `json:"author"`
	CreatedAt string          `json:"createdAt"`
}
