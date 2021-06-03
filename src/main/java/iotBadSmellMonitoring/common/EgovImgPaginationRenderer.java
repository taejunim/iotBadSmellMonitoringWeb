package iotBadSmellMonitoring.common;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;

public class EgovImgPaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;

	public EgovImgPaginationRenderer() {
		// no-op
	}

	public void initVariables() {

		firstPageLabel = "<a href=\"#\" class='pg_start' onclick=\"{0}({1}); return false;\"></a>&#160;";
		previousPageLabel = "<a href=\"#\" class='pg_prev' onclick=\"{0}({1}); return false;\"></a>&#160;";
		currentPageLabel = "<strong>{0}</strong>&#160;";
		otherPageLabel = "<a class='page' href=\"#\" onclick=\"{0}({1}); return false;\">{2}</a>&#160;";
		nextPageLabel = "<a href=\"#\" class='pg_next' onclick=\"{0}({1}); return false;\"></a>&#160;";
		lastPageLabel = "<a href=\"#\" class='pg_end' onclick=\"{0}({1}); return false;\"></a>&#160;";
	}

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}

}
