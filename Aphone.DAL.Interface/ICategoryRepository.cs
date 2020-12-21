using Aphone.Domain.Request.Category;
using Aphone.Domain.Response.Category;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Aphone.DAL.Interface
{
    public interface ICategoryRepository
    {
        Task<IEnumerable<Category>> Gets();
        Task<CreateCategoryResult> CreateCategory(CreateCategoryRequest request);
        Task<UpdateCategoryResult> UpdateCategory(UpdateCategoryRequest request);
        Task<DeleteCategoryResult> DeleteCategory(DeleteCategoryRequest request);
    }
}
