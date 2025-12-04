using System;
using System.Web.UI;

namespace HR
{
    public partial class EmployeeHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeID"] == null)
            {
                Response.Redirect("LogIn.aspx");
                return;
            }

            if (!IsPostBack)
            {
                empName.Text = Session["EmployeeID"].ToString();
            }
        }
    }
}
