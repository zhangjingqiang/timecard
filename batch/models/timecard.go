package models

type Timecard struct {
	ID    int    `json:"id" gorm:"primary_key"`
	Date  string `json: "date"`
	Start string `json: "start"`
	End   string `json: "end"`
	Rest  string `json: "rest"`
	Note  string `json: "note"`
}

type Tabler interface {
	TableName() string
}

func (Timecard) TableName() string {
	return "timecard"
}
